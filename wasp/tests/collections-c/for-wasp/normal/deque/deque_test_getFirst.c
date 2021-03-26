#include "deque.h"
#include "mockups.h" 

static Deque *deque;
static DequeConf conf;
int stat;

void setup_tests() { stat = deque_new(&deque); }

void teardown_tests() { deque_destroy(deque); }

int main() {
    setup_tests();

    int a = dyn_sym_int32('a');
    int b = dyn_sym_int32('b');
    int c = dyn_sym_int32('c');

    deque_add_first(deque, &a);
    deque_add_last(deque, &b);
    deque_add_first(deque, &c);

    int *first;
    deque_get_first(deque, (void *)&first);

    assert(c == *first);

    teardown_tests();
    return 0;
}
