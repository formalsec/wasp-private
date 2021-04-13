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

    int a = sym_int("a", 32);
    int b = sym_int("b", 32);
    int c = sym_int("c", 32);

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
