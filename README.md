# GIF Search Application

Flutter version: 3.22.3

## The Task
Create a gif search application using the Giphy service

## Notes

I failed to implement unit tests that would fit.
Overall, I added 2 unit tests:
- **main_test.dart**: to ensure that the main application is built correctly and is displayed as expected
- **gify_main_page_test.dart**: to show loading indicator while fetching data, display an error message if data fetch fails, and display GIFs correctly when data fetch succeeds (unsuccessful)

The problem occurred with gify_main_page_test.dart due to syntax errors that I could not solve on my own.
