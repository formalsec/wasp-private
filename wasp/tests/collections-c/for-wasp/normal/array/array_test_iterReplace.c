#include "array.h"
#include "mockups.h" 

static Array *v1;
static Array *v2;
static ArrayConf vc;
static int stat;

int main() {
    stat = array_new(&v1);

    int a = dyn_sym_int32('a');
    int b = dyn_sym_int32('b');
    int c = dyn_sym_int32('c');
    int d = dyn_sym_int32('d');

    int replacement = dyn_sym_int32('replacement');

    assume(c != a && c != b && c != d && c != replacement);

    array_add(v1, &a);
    array_add(v1, &b);
    array_add(v1, &c);
    array_add(v1, &d);

    ArrayIter iter;
    array_iter_init(&iter, v1);

    int *e;
    int *old;
    while (array_iter_next(&iter, (void *)&e) != CC_ITER_END) {
        if (*e == c)
            array_iter_replace(&iter, (void *)&replacement, (void *)&old);
    }

    size_t index;
    array_index_of(v1, (void *)&replacement, &index);

    assert(2 == index);
    assert(0 == array_contains(v1, &c));

    array_destroy(v1);

    return 0;
}
