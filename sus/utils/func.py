def ask_bool(question: str) -> bool:
    while True:
        answer = input(f"{question} (y/n): ")

        if answer.lower() in ['y', 'yes']:
            return True
        elif answer.lower() in ['n', 'no']:
            return False
        else:
            print("Please enter Yes or No.")


def ask_str(question: str, default: str | None = None, allow_none=True, options: list[str] = None) -> str:    
    while True:
        question_suffix = ''
        
        if options is not None:
            question_suffix += f" ({'|'.join(options)})"
       
        if default is not None:
            question_suffix += f" (default={default})"
        
        answer = input(f"{question}{question_suffix}: ")

        if answer == '':
            answer = default

        if answer is None and not allow_none:
            print("Input cannot be empty, try again.")
        elif options is not None and answer not in options and answer is None and not allow_none:
            print(f"Input must be one of the following: {', '.join(options)}")
        else:
            return answer
