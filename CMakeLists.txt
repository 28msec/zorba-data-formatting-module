# Copyright 2006-2010 The FLWOR Foundation.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

MESSAGE (STATUS "******** BEGIN Configuring module Data-Formatting ********")

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

PROJECT (zorba_data-formatting_module)

FIND_PACKAGE (zorba_util-jvm_module QUIET)

IF (zorba_util-jvm_module_FOUND)
  INCLUDE ("${zorba_util-jvm_module_USE_FILE}")

  FIND_PACKAGE(JNI)
  FIND_PACKAGE(Java)
  FIND_PACKAGE (Zorba REQUIRED HINTS "${ZORBA_BUILD_DIR}")
  INCLUDE ("${Zorba_USE_FILE}")

  IF (JNI_FOUND)
    INCLUDE_DIRECTORIES (${zorba_util-jvm_module_INCLUDE_DIRS})

    ENABLE_TESTING ()
    INCLUDE (CTest)

    SET_CMAKE_MODULE_PATH ()

    FIND_PACKAGE (Zorba REQUIRED HINTS "${ZORBA_BUILD_DIR}")
    INCLUDE ("${Zorba_USE_FILE}")

    ADD_SUBDIRECTORY ("src")
    #ADD_TEST_DIRECTORY ("${CMAKE_SOURCE_DIR}/test")

    DONE_DECLARING_ZORBA_URIS ()

  ELSE (JNI_FOUND)
    MESSAGE ( STATUS "Java and/or JNI not found; skipping data-formating module.")
  ENDIF(JNI_FOUND)

ELSE (zorba_util-jvm_module_FOUND)
  MESSAGE (STATUS "Zorba's util-jvm module not found; skipping data-formatting module.")
ENDIF (zorba_util-jvm_module_FOUND)


MESSAGE (STATUS "******** END Configuring module Data-Formatting ********")
