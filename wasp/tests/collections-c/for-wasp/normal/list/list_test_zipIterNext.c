#include "list.h"
#include "utils.h"
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

    char str_a[] = {a, '\0'};

    int b = sym_int("b", 32);

    char str_b[] = {b, '\0'};

    int c = sym_int("c", 32);

    char str_c[] = {c, '\0'};

    int d = sym_int("d", 32);

    char str_d[] = {d, '\0'};

    int e = sym_int("e", 32);

    char str_e[] = {e, '\0'};

    int f = sym_int("f", 32);

    char str_f[] = {f, '\0'};

    int g = sym_int("g", 32);

    char str_g[] = {g, '\0'};

    list_add(list1, str_a);
    list_add(list1, str_b);
    list_add(list1, str_c);
    list_add(list1, str_d);

    list_add(list2, str_e);
    list_add(list2, str_f);
    list_add(list2, str_g);

    ListZipIter zip;
    list_zip_iter_init(&zip, list1, list2);

    size_t i = 0;

    void *e1, *e2;
    while (list_zip_iter_next(&zip, &e1, &e2) != CC_ITER_END) {
        if (i == 0) {
            CHECK_EQUAL_C_STRING(str_a, (char *)e1);
            CHECK_EQUAL_C_STRING(str_e, (char *)e2);
        }
        if (i == 2) {
            CHECK_EQUAL_C_STRING(str_c, (char *)e1);
            CHECK_EQUAL_C_STRING(str_g, (char *)e2);
        }
        i++;
    }
    assert(3 == i);

    teardown_test();
}
