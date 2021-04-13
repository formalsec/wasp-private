#include "treetable.h"
#include "utils.h"
#include "mockups.h" 

static TreeTable *table;

int main() {
    treetable_new(cmp, &table);

    int x = sym_int("x", 32);
    int y = sym_int("y", 32);
    int z = sym_int("z", 32);
    int w = sym_int("w", 32);

    int a = sym_int("a", 32);

    char str_a[] = {a, '\0'};

    int b = sym_int("b", 32);

    char str_b[] = {b, '\0'};

    int c = sym_int("c", 32);

    char str_c[] = {c, '\0'};

    assume(z != x && z != y);

    treetable_add(table, &x, str_a);
    treetable_add(table, &y, str_b);
    treetable_add(table, &z, str_c);

    treetable_remove(table, &z, NULL);

    assert(0 == treetable_contains_key(table, &z));

    treetable_destroy(table);
}
