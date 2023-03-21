#pragma once

#include "types.h"

#define ALIGN_UP(X, R) ((((uint64_t)X) + (R) - 1) / (R) * (R))
#define DIV_ROUNDUP(X, R) ((((uint64_t)X) + (R) - 1) / (R))
#define UNUSED(x) (void)(x)

static inline int memcmp(const void* str1, const void* str2, size_t count) {
    const unsigned char *s1 = (const unsigned char*)str1;
    const unsigned char *s2 = (const unsigned char*)str2;
    while (count-- > 0) {
        if (*s1++ != *s2++) {
            return s1[-1] < s2[-1] ? -1 : 1;
        }
    }
    return 0;
}

static inline void memset(void* p, int ch, size_t sz) {
    u8* ptr = (u8*)p;
    while (sz > 0) {
        *ptr = ch;
        ptr++;
        sz--;
    }
}

static inline void memcpy(void* dst, void* src, size_t sz) {
    u8* d = dst;
    const u8* s = src;
    while (sz > 0) {
        *d = *s;
        d++;
        s++;
        sz--;
    }
}

static inline size_t strlen(const char* str) {
	size_t len = 0;
	while (str[len]) {
		len++;
    }
	return len;
}

#define BOCHS_BREAK  { __asm__ volatile ("xchgw %bx, %bx"); };

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

typedef struct mem_region {
    void* start;
    void* end;
} mem_region_t;
