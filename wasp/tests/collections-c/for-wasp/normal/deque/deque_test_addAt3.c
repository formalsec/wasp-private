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
    deque_add_first(deque, &b);
    deque_add_first(deque, &c);
    deque_add_first(deque, &d);
    deque_add_first(deque, &e);
    deque_add_first(deque, &f);

    deque_add_at(deque, &g, 3);

    const void *const *buff = deque_get_buffer(deque);

    const void *elem = buff[6];
    assert(elem == &g);

    const void *elem1 = buff[0];
    assert(elem1 == &b);

    const void *elem2 = buff[7];
    assert(elem2 == &c);

    const void *elem3 = buff[1];
    assert(elem3 == &a);

    teardown_tests();
    return 0;
}
