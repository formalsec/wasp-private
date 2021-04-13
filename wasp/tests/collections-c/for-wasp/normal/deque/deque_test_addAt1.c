#include "deque.h"
#include "mockups.h" 

static Deque *deque;
static DequeConf conf;
int stat;

void setup_tests() { stat = deque_new(&deque); }

void teardown_tests() { deque_destroy(deque); }

int main() {
    setup_tests();

    int a = sym_int("a", 32);
    int b = sym_int("b", 32);
    int c = sym_int("c", 32);
    int d = sym_int("d", 32);
    int e = sym_int("e", 32);
    int f = sym_int("f", 32);
    int g = sym_int("g", 32);

    deque_add_last(deque, &a);
    deque_add_last(deque, &b);
    deque_add_last(deque, &c);
    deque_add_last(deque, &d);
    deque_add_last(deque, &e);
    deque_add_last(deque, &f);

    deque_add_at(deque, &g, 4);

    const void *const *buff = deque_get_buffer(deque);

    assert(buff[4] == &g);

    assert(buff[5] == &e);

    const void *elem = buff[6];
    assert(elem == &f);

    teardown_tests();
    return 0;
}
