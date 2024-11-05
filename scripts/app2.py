import sys

def calculate_average(numbers):
    if len(numbers) == 0:
        return 0
    return sum(numbers) / len(numbers)

if __name__ == "__main__":
    # Convert command-line arguments to floats
    try:
        numbers = [float(arg) for arg in sys.argv[1:]]  # Skip the first argument (script name)
    except ValueError:
        print("Please enter valid numbers.")
        sys.exit(1)
    
    # Calculate the average
    average = calculate_average(numbers)
    
    # Print the average
    print(f"Average: {average}")
