#ifndef ios_util_constants_h
#define ios_util_constants_h

#ifndef metamacro_concat

  #define metamacro_concat(A, B) A ## B

#endif // metamacro_concat

#ifndef weakify

  /*!
   * Call @weakify(varname) to create a weak variant of the given variable. Use in
   * conjunction with @strongify.
   */
  #define weakify(VAR) \
  	autoreleasepool {} \
  	_Pragma("clang diagnostic push") \
  	_Pragma("clang diagnostic ignored \"-Wshadow\"") \
  	__weak __typeof__(VAR) metamacro_concat(VAR, _weak_) = (VAR) \
  	_Pragma("clang diagnostic pop")

  /*!
   * Call @strongify(varname) to create a strong variant of the given variable.
   * Use in conjunction with @weakify.
   */
  #define strongify(VAR) \
  	autoreleasepool {} \
  	_Pragma("clang diagnostic push") \
  	_Pragma("clang diagnostic ignored \"-Wshadow\"") \
  	__strong __typeof__(VAR) VAR = metamacro_concat(VAR, _weak_)\
  	_Pragma("clang diagnostic pop")

#endif // weakify

#endif // ios_util_constants_h
