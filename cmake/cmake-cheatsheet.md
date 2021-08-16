


# Embed git hash in cmake

# Get the latest abbreviated commit hash of the working branch
    
    
execute_process(
    COMMAND git log -1 --format=%h
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    OUTPUT_VARIABLE GIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )

target_compile_definitions(my-target-name PUBLIC ${GIT_HASH})
