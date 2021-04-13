#include "slist.h"
#include "utils.h"
#include "mockups.h" 

static SList *list;
static SList *list2;
static int stat;

void setup_test() {
    stat = slist_new(&list);
    slist_new(&list2);
};

void teardown_test() {
    slist_destroy(list);
    slist_destroy(list2);
};

int main() {
    setup_test();
    int a = sym_int("a", 32);
    assume(a > 0); assume(a < 127);
    char str_a[] = {a, '\0'};

    int b = sym_int("b", 32);
    assume(b > 0); assume(b < 127);
    char str_b[] = {b, '\0'};

    int c = sym_int("c", 32);
    assume(c > 0); assume(c < 127);
    char str_c[] = {c, '\0'};

    int d = sym_int("d", 32);
    assume(d > 0); assume(d < 127);
    char str_d[] = {d, '\0'};

    int e = sym_int("e", 32);
    assume(e > 0); assume(e < 127);
    char str_e[] = {e, '\0'};

    int f = sym_int("f", 32);
    assume(f > 0); assume(f < 127);
    char str_f[] = {f, '\0'};

    int g = sym_int("g", 32);
    assume(g > 0); assume(g < 127);
    char str_g[] = {g, '\0'};

    int h = sym_int("h", 32);
    assume(h > 0); assume(h < 127);
    char str_h[] = {h, '\0'};

    int i = sym_int("i", 32);
    assume(i > 0); assume(i < 127);
    char str_i[] = {i, '\0'};

    int x = sym_int("x", 32);
    assume(x > 0); assume(x < 127);
    char str_x[] = {x, '\0'};

    int y = sym_int("y", 32);
    assume(y > 0); assume(y < 127);
    char str_y[] = {y, '\0'};

    assume(b != a && b != c && b != d);
    assume(h != a && h != b && h != c && h != d);
    assume(c != a && c != d);
    assume(i != e && i != f && i != g);

    slist_add(list, str_a);
    slist_add(list, str_b);
    slist_add(list, str_c);
    slist_add(list, str_d);

    slist_add(list2, str_e);
    slist_add(list2, str_f);
    slist_add(list2, str_g);

    SListZipIter zip;
    slist_zip_iter_init(&zip, list, list2);

    void *e1, *e2;
    while (slist_zip_iter_next(&zip, &e1, &e2) != CC_ITER_END) {
        if (strcmp((char *)e1, str_b) == 0)
            slist_zip_iter_add(&zip, str_h, str_i);
    }

    size_t index;
    slist_index_of(list, str_h, &index);
    assert(2 == index);

    slist_index_of(list2, str_i, &index);
    assert(2 == index);

    slist_index_of(list, str_c, &index);
    assert(3 == index);

    assert(1 == slist_contains(list, str_h));
    assert(1 == slist_contains(list2, str_i));
    assert(5 == slist_size(list));
    assert(4 == slist_size(list2));

    slist_zip_iter_init(&zip, list, list2);
    while (slist_zip_iter_next(&zip, &e1, &e2) != CC_ITER_END) {
        if (strcmp((char *)e2, str_g) == 0)
            slist_zip_iter_add(&zip, str_x, str_y);
    }

    char *last;
    slist_get_last(list2, (void *)&last);
    assert(str_y == last);

    slist_get_last(list, (void *)&last);
    assert(str_d == last);

    teardown_test();
    return 0;
}
