//===-- serialbox-c/UnittestErrorHandling.cpp ---------------------------------------*- C++ -*-===//
//
//                                    S E R I A L B O X
//
// This file is distributed under terms of BSD license.
// See LICENSE.txt for more information
//
//===------------------------------------------------------------------------------------------===//
//
/// \file
/// This file implements the unittests of the C Interface ErrorHandling.
///
//===------------------------------------------------------------------------------------------===//

#include "serialbox-c/ErrorHandling.h"
#include <gtest/gtest.h>

TEST(CErrorHandling, DefaultErrorHandler) {
#if defined(SERIALBOX_RUN_DEATH_TESTS) && !defined(NDEBUG)
  serialboxResetFatalErrorHandler();
  ASSERT_DEATH_IF_SUPPORTED(serialboxFatalError("blub"), "Serialbox: ERROR: blub");
#endif
}

TEST(CErrorHandling, StateErrorHandler) {
  serialboxInstallFatalErrorHandler(serialboxStateErrorHandler);
  
  int hasError;
  char* errorMessage;
 
  //
  // Initial state: No error
  //
  serialboxStateErrorHandlerGetCurrentError(&hasError, &errorMessage);
  ASSERT_FALSE(hasError);
  ASSERT_EQ(NULL, errorMessage);

  //
  // Raise error
  //
  serialboxFatalError("error");
  
  serialboxStateErrorHandlerGetCurrentErrorAndReset(&hasError, &errorMessage);
  ASSERT_TRUE(hasError);
  ASSERT_STREQ(errorMessage, "error");
  serialboxStateErrorHandlerGetCurrentError(&hasError, &errorMessage);
  ASSERT_FALSE(hasError);
  ASSERT_EQ(NULL, errorMessage);
}

