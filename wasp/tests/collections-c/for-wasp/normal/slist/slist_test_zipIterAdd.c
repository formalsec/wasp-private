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
    int a = dyn_sym_int32('a');
    assume(a > 0); assume(a < 127);
    char str_a[] = {a, '\0'};

    int b = dyn_sym_int32('b');
    assume(b > 0); assume(b < 127);
    char str_b[] = {b, '\0'};

    int c = dyn_sym_int32('c');
    assume(c > 0); assume(c < 127);
    char str_c[] = {c, '\0'};

    int d = dyn_sym_int32('d');
    assume(d > 0); assume(d < 127);
    char str_d[] = {d, '\0'};

    int e = dyn_sym_int32('e');
    assume(e > 0); assume(e < 127);
    char str_e[] = {e, '\0'};

    int f = dyn_sym_int32('f');
    assume(f > 0); assume(f < 127);
    char str_f[] = {f, '\0'};

    int g = dyn_sym_int32('g');
    assume(g > 0); assume(g < 127);
    char str_g[] = {g, '\0'};

    int h = dyn_sym_int32('h');
    assume(h > 0); assume(h < 127);
    char str_h[] = {h, '\0'};

    int i = dyn_sym_int32('i');
    assume(i > 0); assume(i < 127);
    char str_i[] = {i, '\0'};

    int x = dyn_sym_int32('x');
    assume(x > 0); assume(x < 127);
    char str_x[] = {x, '\0'};

    int y = dyn_sym_int32('y');
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
