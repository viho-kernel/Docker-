def greet(name):
    """Function to greet a user"""
    return f"Hello, {name}!"

def add_numbers(a, b):
    """Function to add two numbers"""
    return a + b

def main():
    """Main function"""
    print("=== Basic Python Application ===\n")
    
    # Get user input
    user_name = input("Enter your name: ")
    greeting = greet(user_name)
    print(greeting)
    
    # Perform calculation
    num1 = float(input("\nEnter first number: "))
    num2 = float(input("Enter second number: "))
    result = add_numbers(num1, num2)
    print(f"\nSum: {num1} + {num2} = {result}")

if __name__ == "__main__":
    main()