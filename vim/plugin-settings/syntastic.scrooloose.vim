"mark syntax errors with :signs
let g:syntastic_enable_signs=1
"automatically jump to the error when saving the file
let g:syntastic_auto_jump=0
"show the error list automatically
let g:syntastic_auto_loc_list=1
"don't care about warnings
let g:syntastic_quiet_messages = {'level': 'warnings'}

let g:syntastic_python_checkers = ['python', 'pylint']

let g:syntastic_python_pylint_post_args = '--rcfile=/dev/null
\ --disable=all
\ -e undefined-variable
\ -e bad-indentation
\ -e fixme --notes=INCOMPLETE
\'

"\ -e function-redefined
"\ -e return-in-init
"\ -e duplicate-key
"\ -e expression-not-assigned
"\ -e pointless-statement
"\ -e bad-super-call
"\ -e missing-super-argument
"\ -e line-too-long --max-line-length=100
"\ -e mixed-line-endings
"\ -e trailing-whitespace
"\ -e super-init-not-called
