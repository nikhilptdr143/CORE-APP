function toggleForm() {
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');

    loginForm.classList.toggle('hidden');
    registerForm.classList.toggle('hidden');
}

document.addEventListener('DOMContentLoaded', function() {
    
    const regForm = document.querySelector('#register-form form');
    if(regForm) {
        regForm.onsubmit = function(e) {
            const u = document.getElementById('reg-user').value.trim();
            const p = document.getElementById('reg-pass').value;
            const cp = document.getElementById('reg-pass-confirm').value;

            if(u === "" || p === "" || cp === "") {
                alert("CORE System: All fields are mandatory!");
                e.preventDefault(); // Form rok do
                return false;
            } else if(p !== cp) {
                alert("CORE System: Passwords do not match!");
                e.preventDefault(); // Form rok do
                return false;
            }
            return true;
        };
    }

    const loginFormElement = document.querySelector('#login-form form');
    if(loginFormElement) {
        loginFormElement.onsubmit = function(e) {
            const u = document.getElementById('login-user').value.trim();
            const p = document.getElementById('login-pass').value;

            if(u === "" || p === "") {
                alert("CORE System: Please enter both Username and Password.");
                e.preventDefault();
                return false;
            }
            return true;
        };
    }
});