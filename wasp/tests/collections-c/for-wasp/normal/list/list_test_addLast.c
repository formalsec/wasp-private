#include "list.h"
#include "mockups.h" 

static List *list1;
static List *list2;

void setup_tests() { list_new(&list1), list_new(&list2); }

void teardown_test() {
    list_destroy(list1);
    list_destroy(list2);
}

int main() {
    setup_tests();

    int a = sym_int("a", 32);
    int b = sym_int("b", 32);
    int c = sym_int("c", 32);
    int d = sym_int("d", 32);
    int p = sym_int("p", 32);

    list_add(list1, &a);
    list_add(list1, &b);
    list_add(list1, &c);
    list_add(list1, &d);

    assert(4 == list_size(list1));

    int *last;
    list_get_last(list1, (void *)&last);
    assert(d == *last);

    list_add_last(list1, &p);
    assert(5 == list_size(list1));

    list_get_last(list1, (void *)&last);
    assert(p == *last);

    teardown_test();
}
