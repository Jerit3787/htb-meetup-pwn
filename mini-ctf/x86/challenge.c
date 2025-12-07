// CTF Challenge - x86 (32-bit)
// Compile: gcc -m32 -fno-stack-protector -no-pie -o challenge challenge.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// gets() removed from modern glibc, declare it manually
extern char *gets(char *s);

// Hidden function - participants need to find this!
void get_flag()
{
    FILE *f = fopen("flag.txt", "r");
    if (f == NULL)
    {
        printf("Flag file not found. Contact admin.\n");
        return;
    }
    char flag[100];
    fgets(flag, sizeof(flag), f);
    printf("\n🚩 %s\n", flag);
    fclose(f);
}

void vuln()
{
    char name[32];

    printf("What's your hacker name? ");
    fflush(stdout);
    gets(name);
    printf("Welcome, %s!\n", name);
}

void menu()
{
    printf("\n");
    printf("1. Enter the system\n");
    printf("2. Exit\n");
    printf("> ");
}

int main()
{
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);

    int choice;

    printf("╔═══════════════════════════════════════════╗\n");
    printf("║     Welcome to SecureLogin v1.0 (x86)     ║\n");
    printf("║        Totally unhackable system!         ║\n");
    printf("╚═══════════════════════════════════════════╝\n");

    menu();
    scanf("%d", &choice);
    getchar();

    if (choice == 1)
    {
        vuln();
        printf("Access granted... or is it?\n");
    }
    else
    {
        printf("Bye!\n");
    }

    return 0;
}
