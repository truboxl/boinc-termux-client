#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

int main(void) {
    printf("%s\n", getenv("LD_PRELOAD"));
    char *c = getenv("LD_PRELOAD");
    unsetenv("LD_PRELOAD");
    printf("%s\n", getenv("LD_PRELOAD"));
    setenv("LD_PRELOAD", c, 1);
    printf("%s\n", getenv("LD_PRELOAD"));
    free(c);
    return 0;
}
