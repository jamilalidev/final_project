#include <security/pam_appl.h>
#include <security/pam_misc.h>

int main() {
    const struct pam_conv conv = {
        misc_conv,
        NULL
    };
    
    pam_handle_t *pamh = NULL;
    int retval;
    
    retval = pam_start("nginx-auth", "myuser", &conv, &pamh);
    
    if (retval != PAM_SUCCESS) {
        fprintf(stderr, "pam_start failed: %s\n", pam_strerror(pamh, retval));
        return 1;
    }
    
    retval = pam_authenticate(pamh, 0);
    
    if (retval != PAM_SUCCESS) {
        fprintf(stderr, "pam_authenticate failed: %s\n", pam_strerror(pamh, retval));
        return 1;
    }
    
    printf("Authentication successful.\n");
    
    pam_end(pamh, retval);
    
    return 0;
}
