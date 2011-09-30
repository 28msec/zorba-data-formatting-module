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

#
# JNI JAVA
#
IF (ZORBA_SUPPRESS_JAVA)
  MESSAGE(STATUS "ZORBA_SUPPRESS_JNI is true - not searching for Java")
ELSE (ZORBA_SUPPRESS_JAVA)  
  MESSAGE (STATUS "Looking for JNI")
  FIND_PACKAGE(JNI)
  
  MESSAGE (STATUS "Looking for Java")
  FIND_PACKAGE(Java)

  IF (JNI_FOUND)
    SET(ZORBA_WITH_FOP ON CACHE BOOL "Compile Zorba with XSL-FO support" FORCE)
    IF (ZORBA_WITH_FOP)
      INCLUDE (CMakeJavaInformation )
      MESSAGE(STATUS "Generating Java API")
      EXECUTE_PROCESS ( COMMAND ${JAVA_RUNTIME} -version
                        RESULT_VARIABLE JAVA_VERSION
                        OUTPUT_QUIET
                        ERROR_QUIET)
      MESSAGE(STATUS "JNI found at    :${JAVA_INCLUDE_PATH}")
      MESSAGE(STATUS "Java Library at :${JAVA_JVM_LIBRARY}")
      MESSAGE(STATUS "Building Zorba with XSL-FO support.")
  
      INCLUDE_DIRECTORIES(${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2})
      INCLUDE_DIRECTORIES(${JAVA_INCLUDE_PATH})
      DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/xsl-fo" VERSION 1.0 FILE "xsl-fo.xq" LINK_LIBRARIES "${JAVA_JVM_LIBRARY}")
    ELSE (JNI_FOUND)
      IF (ZORBA_WITH_FOP)
        MESSAGE(FATAL_ERROR "Could not find Java and/or JNI. Please install a JDK or compile Zorba with XSL-FO support by setting ZORBA_WITH_FOP to false.")
      ENDIF (ZORBA_WITH_FOP)
      MESSAGE ( STATUS "Not generating XSL-FO support: jni headers not found.")
    ENDIF()
  ELSE ()
    SET(ZORBA_WITH_FOP OFF CACHE BOOL "Compile Zorba with XSL-FO support." FORCE)
    MESSAGE(STATUS "Building Zorba without XSL-FO support.")
  ENDIF ()
ENDIF(ZORBA_SUPPRESS_JAVA)
MESSAGE(STATUS "")
