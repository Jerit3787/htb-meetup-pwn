// Hands-on Challenge - x64 (64-bit)
// Compile: gcc -fno-stack-protector -no-pie -o challenge challenge.c
#include <stdio.h>
#include <stdlib.h>

void win()
{
    printf("\n🎉 Congratulations! You solved the x64 hands-on!\n");
    printf("FLAG{x64_r3t2w1n_b4s1cs}\n\n");
}

void vulnerable()
{
    char buffer[64];

    printf("Enter your input: ");
    fflush(stdout);
    gets(buffer);
    printf("You entered: %s\n", buffer);
}

int main()
{
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);

    printf("╔════════════════════════════════════════╗\n");
    printf("║   Hands-on Challenge - x64 (64-bit)    ║\n");
    printf("╚════════════════════════════════════════╝\n\n");

    vulnerable();

    printf("Goodbye!\n");
    return 0;
}
