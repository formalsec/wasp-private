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

    deque_add(deque, &a);
    deque_add(deque, &b);
    deque_add(deque, &c);

    assert(8 == deque_capacity(deque));

    deque_trim_capacity(deque);

    assert(4 == deque_capacity(deque));

    teardown_tests();
    return 0;
}
