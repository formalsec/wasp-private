#include "queue.h"
#include "mockups.h" 

static Queue *q;
static Queue *q2;
static int stat;

void setup_test() {
    stat = queue_new(&q);
    queue_new(&q2);
}

void teardown_test() {
    queue_destroy(q);
    queue_destroy(q2);
}

int main() {
    setup_test();

    int a = dyn_sym_int32('a');
    int b = dyn_sym_int32('b');
    int c = dyn_sym_int32('c');

    queue_enqueue(q, &a);
    queue_enqueue(q, &b);

    assert(2 == queue_size(q));

    void *p;
    queue_peek(q, &p);
    assert(&a == p);

    queue_enqueue(q, &c);

    queue_peek(q, &p);
    assert(&a == p);

    teardown_test();
    return 0;
}
