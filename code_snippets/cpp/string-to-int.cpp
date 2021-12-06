//Requires at least C++17 (for string_view and from_chars)
#include <charconv>
#include <iomanip>
#include <iostream>
#include <string_view>
#include <system_error>
 
int main()
{
    for (std::string_view const str : {"15 foo", "bar", " 42", "5000000000"}) {
 
        std::cout << "String: " << std::quoted(str) << ". ";
 
        int result{};
 
        auto [ptr, ec] { std::from_chars(str.data(), str.data() + str.size(), result) };
 
        if (ec == std::errc())
        {
            std::cout << "Result: " << result << ", ptr -> " << std::quoted(ptr) << '\n';
        }
        else if (ec == std::errc::invalid_argument)
        {
            std::cout << "That isn't a number.\n";
        }
        else if (ec == std::errc::result_out_of_range)
        {
            std::cout << "This number is larger than an int.\n";
        }
    }
}
