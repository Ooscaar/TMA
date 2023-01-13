#include <ncurses.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include <regex.h>
#include <pthread.h>

#define TABLE_COLS 8
#define FLOW_REFRESH_SECONDS 10

void do_resize(void);
void setup_bar(void);
void setup_data(void);
int write_flows(int);
void write_log(char log[]);

typedef struct Flow {
    char id[50];
    bool active;
    char src_ip[16];
    char dst_ip[16];
    char protocol[4]; // TCP or UDP
    char src_port[6];
    char dst_port[6];
    char speed[10]; // Bps
    char traff[10]; // Bits
} Flow;

static WINDOW* window_bar;
static WINDOW* window_filter;
static WINDOW* window_data;
static WINDOW* window_flows;

static bool writeMode = FALSE;
static char filterString[100];
static char filterStringTemp[100];

static Flow* flows = NULL;
static int flowsNumber;
static Flow* flowsRegex;
static int flowsRegexNumber;

static bool pauseFlows = FALSE;

static int position;
static int windowPositions[2] = {-1, -1};

void readFlows(void) {
    Flow* newFlows = (Flow*) malloc(sizeof(Flow));
    FILE* flowsFile = fopen("./flows.csv", "r");

    char atribute[30] = {0};
    int atrCounter = 0;
    int flowsCounter = 0;
    
    while(1) {
        char c = (char)fgetc(flowsFile);

        // Add characters
        if(c != ' ' && c != ',' && c != '\n' && c != EOF) {
            sprintf(atribute, "%s%c", atribute, c); // Attach the character to the string
        }
        // Get atribute
        if(c == ',' || c == '\n' || c == EOF) {
            if(atrCounter == 0) strcpy(newFlows[flowsCounter].id, atribute);
            else if(atrCounter == 1) newFlows[flowsCounter].active = strcmp("0", atribute);
            else if(atrCounter == 2) strcpy(newFlows[flowsCounter].src_ip, atribute);
            else if(atrCounter == 3) strcpy(newFlows[flowsCounter].dst_ip, atribute);
            else if(atrCounter == 4) strcpy(newFlows[flowsCounter].protocol, atribute);
            else if(atrCounter == 5) strcpy(newFlows[flowsCounter].src_port, atribute);
            else if(atrCounter == 6) strcpy(newFlows[flowsCounter].dst_port, atribute);
            else if(atrCounter == 7) strcpy(newFlows[flowsCounter].speed, atribute);
            else if(atrCounter == 8) strcpy(newFlows[flowsCounter].traff, atribute);

            memset(atribute, 0, sizeof(atribute)); // Restart the atribute
            atrCounter++;
        }
        // Get flow
        if(c == '\n') {
            // If we have a '\n' we will have another flow, so add more memory
            flowsCounter++;
            newFlows = realloc(newFlows, sizeof(Flow) * (flowsCounter + 1));
            atrCounter = 0;
        }
        if(c == EOF) break;
    }

    fclose(flowsFile);

    flowsNumber = flowsCounter + 1;

    // Free memory if needed
    if(flows == NULL) {
        flows = newFlows;
    } else {
        Flow* oldFlows = flows;
        flows = newFlows;
        free(oldFlows);
    }
}

int filterFlows(void) {
    char item[200];
    flowsRegex = malloc(0);
    flowsRegexNumber = 0;
    regex_t regex;
    // If there is no filter ignore the regex
    if(strlen(filterString) == 0) {
        flowsRegex = flows;
        flowsRegexNumber = flowsNumber;
    }
    else {
        int result = regcomp(&regex, filterString, REG_EXTENDED);
        if(result != 0) return 1;

        // Get the flows that match the regex
        for(int i = 0; i < flowsNumber; i++) {
            sprintf(item, "%s %s %s %s %s", flows[i].src_ip, flows[i].dst_ip, 
                flows[i].protocol, flows[i].src_port, flows[i].dst_port);
            
            // If there is no regex match ignore the flow
            int result = regexec(&regex, item, 0, NULL, 0);
            memset(item, 0, sizeof(item)); // Restart the item
            if(result != 0) continue;
            // If there is regex match store it in flowsRegex
            flowsRegexNumber++;
            flowsRegex = realloc(flowsRegex, sizeof(Flow) * (flowsRegexNumber));
            flowsRegex[flowsRegexNumber - 1] = flows[i];
        }
    }

    return 0;
}

void* updateFlows(void* arg) {
    while(true) {
        if(!pauseFlows) {
            readFlows();
            write_flows(0);
        }
        sleep(FLOW_REFRESH_SECONDS);
    }
}

void blockFlow() {
    char* flowId = flowsRegex[position].id;
    write_log(flowId);

    flowsRegex[position].active = FALSE;
    write_flows(0);
}

void do_resize(void) {
  werase(window_bar);
  setup_bar();

  werase(window_data);
  setup_data();
}

void setup_bar() {
    int barHeight = 3, barWidth = COLS, barY = 0, barX = 0;
    char barTitle[] = "Menu";
    char barMenus[3][20] = {"[Q] Quit", "[P] Pause", "[F] Filter:"};

    window_bar = newwin(barHeight, barWidth, barY, barX);
    box(window_bar, 0, 0);

    // Print window_bar title
    wattron(window_bar, A_BOLD);
    mvwprintw(window_bar, 0, 1, barTitle);
    wattroff(window_bar, A_BOLD);
    // Print window_bar menus
    mvwprintw(window_bar, 1, 1, ""); // Move the cursor
    for (int i = 0; i < 3; i++) {
        if (i == 1 && pauseFlows) {
            wprintw(window_bar, " ");
            wattron(window_bar, A_STANDOUT);
            wprintw(window_bar, "%s", barMenus[i]);
            wattroff(window_bar, A_STANDOUT);
            wprintw(window_bar, " |");
        }
        else if(i != 2) wprintw(window_bar, " %s |", barMenus[i]);
        else wprintw(window_bar, " %s ", barMenus[i]);
    }
    wrefresh(window_bar);
    
    // Generate the window with the filter
    window_filter = newwin(1, barWidth - 38, 1, 37);;
    wrefresh(window_filter);
}

void write_log(char log[]) {
    wprintw(window_bar, " %s ", log);
    wrefresh(window_bar);
}

void write_filter(int character) {
    // Print the charactedr if it is printable
    if(isprint(character)) {
        sprintf(filterStringTemp, "%s%c", filterStringTemp, character);
    }
    else if (character == KEY_BACKSPACE || character == 127) {
        int length = strlen(filterStringTemp);
        if(length > 0) filterStringTemp[length - 1] = '\0';
    }
    werase(window_filter);
    wprintw(window_filter, "%s", filterStringTemp);
    wrefresh(window_filter);
}

void setup_data() {
    int dataHeight = LINES - 3, dataWidth = COLS, dataY = 3, dataX = 0;
    char dataTitle[] = "Info";

    window_data = newwin(dataHeight, dataWidth, dataY, dataX);
    box(window_data, 0, 0);

    // Print window_data title
    wattron(window_data, A_BOLD);
    mvwprintw(window_data, 0, 1, dataTitle);
    wattroff(window_data, A_BOLD);

    wrefresh(window_data);

    window_flows = newwin(dataHeight - 4, dataWidth - 4, 6, 2);
}

int write_flows(int diff) {
    char header[TABLE_COLS][20] = {"?", "Source IP", "Destination IP", "Protocol", "Src Port", "Dst Port", "Speed", "Total data"};
    int maxFlows = getmaxy(window_flows);
    int tableWidth = getmaxx(window_flows);
    werase(window_flows);

    int columnWidths[TABLE_COLS] = {2, 17, 17, 10, 10, 10,  
        (tableWidth - 17 - 17 - 10 - 10 - 10 - 2) / 2,
        (tableWidth - 17 - 17 - 10 - 10 - 10 - 2) / 2
    };
    if(tableWidth % 2 == 1) columnWidths[TABLE_COLS-1]++;

    char item[500] = "";
    // Print the data header (The header is in the window_data)
    memset(item, 0, sizeof(item));
    for(int i = 0; i < TABLE_COLS; i++) {
        sprintf(item, "%s%-*s", item, columnWidths[i], header[i]);
    }
    wattron(window_data, A_BOLD);
    mvwprintw(window_data, 1, 2, "%s", item);
    wattroff(window_data, A_BOLD);
    wrefresh(window_data);
    memset(item, 0, sizeof(item));

    int filterResult = filterFlows(); // Filter the flows
    if(filterResult) {
        // Error filtering
        return position;
    }

    if(windowPositions[0] == -1) {
        windowPositions[0] = 0;
        windowPositions[1] = maxFlows - 1;
    }

    position += diff;
    // Position cannot be smaller than 0
    position = (position < 0) ? 0 : position;
    // Position cannot be bigger than flowsNumber
    position = (position > flowsRegexNumber - 1) ? flowsRegexNumber - 1 : position;

    // Check resize
    if (windowPositions[1] - windowPositions[0] + 1 != maxFlows) { // If now there is less space
        windowPositions[1] = windowPositions[0] + maxFlows - 1;
    }

    // Adjust the window position to do not lose the position
    if (windowPositions[0] > position) {
        windowPositions[0] = position;
        windowPositions[1] = position + maxFlows - 1;
    } else if (windowPositions[1] < position) {
        windowPositions[1] = position;
        windowPositions[0] = position - maxFlows + 1;
    }

    // If there is space below use it
    if(windowPositions[1] > flowsRegexNumber && windowPositions[0] != 0) {
        windowPositions[1] = flowsRegexNumber;
        windowPositions[0] = windowPositions[1] - maxFlows;
    }

    if (windowPositions[1] - windowPositions[0] >= maxFlows) {
        windowPositions[0] = 0;
        windowPositions[1] = maxFlows - 1;
    }

    for(int i = 0; i < flowsRegexNumber; i++) {

        if(i < windowPositions[0] || i > windowPositions[1]) continue;

        // highlights the correct item
        if (i == position && !writeMode) wattron(window_flows, A_STANDOUT);
        else wattroff(window_flows, A_STANDOUT);
        char item[500] = {0};

        if(flowsRegex[i].active) {
            sprintf(item, "%s%-*s", item, columnWidths[0], "");
        } else {
            sprintf(item, "%s%-*s", item, columnWidths[0], "X");
        }
        sprintf(item, "%s%-*s", item, columnWidths[1], flowsRegex[i].src_ip);
        sprintf(item, "%s%-*s", item, columnWidths[2], flowsRegex[i].dst_ip);
        sprintf(item, "%s%-*s", item, columnWidths[3], flowsRegex[i].protocol);
        sprintf(item, "%s%-*s", item, columnWidths[4], flowsRegex[i].src_port);
        sprintf(item, "%s%-*s", item, columnWidths[5], flowsRegex[i].dst_port);
        sprintf(item, "%s%-*s", item, columnWidths[6], flowsRegex[i].speed);
        sprintf(item, "%s%-*s", item, columnWidths[7], flowsRegex[i].traff);

        mvwprintw(window_flows, i - windowPositions[0], 0, "%s", item);
        wattroff(window_flows, A_STANDOUT);
        memset(item, 0, sizeof(item)); // Restart the item
    }

    wrefresh(window_flows); // update the terminal screen
    keypad(window_data, TRUE); // enable keyboard input for the window.

    // If we are in write mode move the cursor to the filter screen
    if(writeMode) {
        write_filter('\0');
    }

    return position;
}

int main() {

    memset(filterString, 0, sizeof(filterString));
    memset(filterStringTemp, 0, sizeof(filterStringTemp));
    int ch = 0;
    
    initscr(); // initialize Ncurses

    setup_bar();
    setup_data();
    write_flows(0);

    noecho(); // disable echoing of characters on the screen
    curs_set(0); // hide the default screen cursor.
    set_escdelay(0); // remove the ESC delay

    pthread_t threadFlows;
    int rc = pthread_create(&threadFlows, NULL, updateFlows, NULL);
    if(rc) {
        // Error creating the thread
        return 1;
    }

    // get the input
    while ((ch = wgetch(window_data)) != 'q') {
        // use a variable to increment or decrement the value based on the input.
        if(ch == KEY_RESIZE) {
            do_resize();
            write_flows(0);
        }

        if(!writeMode) {
            switch (ch) {
                case KEY_UP:
                    write_flows(-1);
                    break;
                case KEY_DOWN:
                    write_flows(1);
                    break;
                case 'f':
                    writeMode = TRUE;
                    write_flows(0);
                    curs_set(1);
                    wrefresh(window_filter);
                    break;
                case 'p':
                    pauseFlows = !pauseFlows;
                    write_flows(0);
                    setup_bar();
                    break;
                case '\n':
                    // Block the selected flow
                    blockFlow();
                    break;
            }
        } else {
            switch (ch) {
                // Exit writeMode using the ESC key
                case 27:
                    writeMode = FALSE;
                    write_flows(0);
                    curs_set(0);
                    wrefresh(window_filter);
                    break;
                case '\n':
                    strcpy(filterString, filterStringTemp);
                    position = 0;
                    char str[100];
                    sprintf(str, "%d", position);
                    write_log(str);
                    write_flows(0);
                    write_filter('\0');
                    break;
                default:
                    write_filter(ch);
            }
        }
    }
    pthread_kill(threadFlows, SIGKILL);
    delwin(window_data);
    endwin();
    
    return 0;
}
