#include "deque.h"
#include "mockups.h" 

static Deque *deque;
static DequeConf conf;
int stat;

void setup_tests() { stat = deque_new(&deque); }

void teardown_tests() { deque_destroy(deque); }

bool pred1(const void *e) { return *(int *)e <= 3; }

bool pred2(const void *e) { return *(int *)e > 3; }

bool pred3(const void *e) { return *(int *)e > 5; }

int main() {
    setup_tests();

    int a = dyn_sym_int32('a');
    int b = dyn_sym_int32('b');
    int c = dyn_sym_int32('c');
    int d = dyn_sym_int32('d');
    int e = dyn_sym_int32('e');
    int f = dyn_sym_int32('f');

    assume(!pred1(&d) && !pred1(&e) && !pred1(&f) && pred1(&a) && pred1(&b) &&
           pred1(&c));

    deque_add_last(deque, (void*)&a);
    deque_add_last(deque, (void*)&b);
    deque_add_last(deque, (void*)&c);
    deque_add_last(deque, (void*)&d);
    deque_add_last(deque, (void*)&e);
    deque_add_last(deque, (void*)&f);
    assert(6 == deque_size(deque));

    Deque *filter = NULL;
    deque_filter(deque, pred1, &filter);
    assert(3 == deque_size(filter));
    const void *const *buff = deque_get_buffer(filter);

    assert(buff[0] == &a);
    assert(buff[1] == &b);

    const void *elem = buff[2];
    assert(elem == &c);
    free(filter);

    teardown_tests();
    return 0;
}
