#ifndef SH_PORT_H
#define SH_PORT_H

/*
 * cohsh porting header.
 * Copyright (c) 2025 Mario (@wordatet)
 * Licensed under the GNU General Public License v3.0.
 */

#include <stddef.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <setjmp.h>
#include <errno.h>
#include <ctype.h>
#include <stdint.h>
#include <signal.h>

/* Basic Compatibility Macros */
#define PROTO(p) p
#define ARGS(x) x
#define __ARGS(x) x
#define CONST const
#define VOLATILE volatile
#define VOID void
#define LOCAL static
#define REGISTER register
#define EXTERN_C
#define EXTERN_C_BEGIN
#define EXTERN_C_END
#define USE_PROTO 1
#define NOTUSED(x) x

#ifdef __GNUC__
#define NO_RETURN __attribute__((noreturn)) void
#else
#define NO_RETURN void
#endif

/* Token Pasting */
#ifndef __CONCAT
#define __CONCAT(x,y) x##y
#endif
#ifndef __CONCAT3
#define __CONCAT3(x,y,z) x##y##z
#endif
#ifndef __CONCAT4
#define __CONCAT4(a,b,c,d) a##b##c##d
#endif

/* Stringizing */
#ifndef __STRING
#define __STRING(x) #x
#endif
#ifndef __STRINGVAL
#define __STRINGVAL(x) __STRING(x)
#endif
#ifndef STRING
#define STRING(x) __STRING(x)
#endif

/* Trick macros - simplified for modern systems */
#define __ARRAY_LENGTH(a) (sizeof(a)/sizeof((a)[0]))
#define __MIN(a,b) ((a)<(b)?(a):(b))
#define __MAX(a,b) ((a)>(b)?(a):(b))

/* Shell Specifics */
#ifndef STDOUT_FILENO
#define STDOUT_FILENO 1
#endif
#ifndef STDERR_FILENO
#define STDERR_FILENO 2
#endif

#ifndef SIG_HOLD
#define SIG_HOLD ((void (*)(int)) 2)
#endif

/* Forward Declarations of Internal Shell Types */
struct ses;
struct node;
struct buf;
struct redir_undo;
typedef struct redir_undo REDIR_UNDO;

/* Forward Declarations of Internal Shell Functions */
void panic(int i);
int recover(int context);
int session(int t, VOID * p, int flags);
int push_session(int type, VOID *info, struct ses *session, int flags);
void pop_session(struct ses *session);
int evalhere(int u2);
int glob1(char *args);
int match(char *pp, char *sp);
void def_shell_fn(struct node *np);
void subshell_shell_fns(void);
int pipeline(int *pv);
void freebuf(struct buf **bpp);
void dflttrp(int context);
int telltrp(void);
int setstrp(int sig, char *actp);
int name2sig(char *name);
void tellvar(int f, int prompt);
void eillvar(CONST char *var);
int redirect(char **iovp, REDIR_UNDO **undo);

/* Internal glob functions */
int glob2(char *patt, int nsep, char *suff);
int mksep(char *cp, int ns);
int newarg(char *p);
int strip(char *s);

/* Lexer/Parser functions */
int lexiors(int c);
int lexname(int c, int flag);
int isnext(int c, int newtok, int oldtok);
int collect(int c, int flag);
void remember_temp(char *name);
void prompt(const char *s);
int yyparse(void);

/* Main/Init functions */
void initvar(char **envp);
int set(int argc, char *CONST *argv, int f);
void checkmail(void);

/* System functions */
mode_t umask(mode_t mask);

#ifndef CLK_TCK
#define CLK_TCK CLOCKS_PER_SEC
#endif

#ifndef VERSION
#define VERSION "V4.2.2"
#endif

#ifndef ARRAY_LENGTH
#define ARRAY_LENGTH(a) (sizeof(a)/sizeof((a)[0]))
#endif

/* Unaligned-safe size_t access */
static inline size_t __get_size(const void *p) {
    size_t s;
    memcpy(&s, p, sizeof(size_t));
    return s;
}
static inline void __set_size(void *p, size_t s) {
    memcpy(p, &s, sizeof(size_t));
}

#endif /* SH_PORT_H */
