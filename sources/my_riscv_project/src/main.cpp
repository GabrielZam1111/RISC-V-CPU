// src/main.cpp
// Simple C++ main with memory store that compiles to store instruction

extern "C" int main() {
    // Simple memory store - compiler will generate store instruction
    volatile int* data_ptr = (volatile int*)0x1000;
    *data_ptr = 0x1234;
    
    // Infinite loop to keep program running
    while(1) {
        __asm__("nop");
    }
    
    return 0;
}