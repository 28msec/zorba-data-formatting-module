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

SET (ZORBA_WITH_FOP ON CACHE BOOL "Compile Zorba with XSL-FO support" FORCE)
IF (ZORBA_WITH_FOP)

  IF (ZORBA_SUPPRESS_JAVA)
    MESSAGE (STATUS "ZORBA_SUPPRESS_JNI is true - not searching for Java")
    MESSAGE (STATUS "Building Zorba without XSL-FO support.")
  ELSE (ZORBA_SUPPRESS_JAVA)

    FIND_PACKAGE(Java)
    FIND_PACKAGE(JNI)  

    IF (JNI_FOUND)
    
      IF (NOT DEFINED XSL_FOP_HOME)
        IF (DEFINED ENV{XSL_FOP_HOME})
          SET(XSL_FOP_HOME $ENV{XSL_FOP_HOME})
        ENDIF (DEFINED ENV{XSL_FOP_HOME})
      ENDIF (NOT DEFINED XSL_FOP_HOME)
      
      IF (NOT DEFINED XSL_FOP_HOME)
        IF (WIN32)
          MESSAGE (STATUS "Environment variable XSL_FOP_HOME not defined, trying default: C:\\dev\\libraries\\fop-1.0")
          SET (XSL_FOP_HOME "C:\\dev\\libraries\\fop-1.0")
        ELSE (WIN32)
          MESSAGE (STATUS "Environment variable XSL_FOP_HOME not defined, trying defaults: " ${Java_LIBRARIES} " /usr/share/java/ /usr/share/java/fop/")
          SET (XSL_FOP_HOME "/usr/share/java/ /usr/share/java/fop/ ${Java_LIBRARIES}")
        ENDIF (WIN32)
      ENDIF (NOT DEFINED XSL_FOP_HOME)
      
      STRING(REGEX REPLACE "\\\\" "/" XSL_FOP_HOME "${XSL_FOP_HOME}")
      
      MESSAGE (STATUS "XSL-FOP HOME: " ${XSL_FOP_HOME} )
      FIND_FILE( FOP_JAR NAMES fop.jar 
        PATHS ${XSL_FOP_HOME} ${XSL_FOP_HOME}/build )
      FIND_FILE( FOP_D1_JAR NAMES avalon-framework.jar
        PATHS ${XSL_FOP_HOME} ${XSL_FOP_HOME}/lib )
      FIND_FILE( FOP_D2_JAR NAMES batik-all.jar
        PATHS ${XSL_FOP_HOME} ${XSL_FOP_HOME}/lib )
      FIND_FILE( FOP_D3_JAR NAMES commons-io.jar
        PATHS ${XSL_FOP_HOME} ${XSL_FOP_HOME}/lib )
      FIND_FILE( FOP_D4_JAR NAMES commons-logging.jar
        PATHS ${XSL_FOP_HOME} ${XSL_FOP_HOME}/lib )
      FIND_FILE( FOP_D5_JAR NAMES serializer.jar
        PATHS ${XSL_FOP_HOME} ${XSL_FOP_HOME}/lib )
      FIND_FILE( FOP_D6_JAR NAMES xalan.jar xalan2.jar
        PATHS ${XSL_FOP_HOME} ${XSL_FOP_HOME}/lib )
      FIND_FILE( FOP_D7_JAR NAMES xmlgraphics-commons.jar
        PATHS ${XSL_FOP_HOME} ${XSL_FOP_HOME}/lib )

      #MULTIPLE EXISTS CAN'T BE USED IN AN *IF* COMMAND, LOOKS LIKE A BUG ON CMAKE
      SET(ALL_FOP FALSE)
      IF ( EXISTS ${FOP_JAR} )
        IF ( EXISTS ${FOP_D1_JAR} )
          IF ( EXISTS ${FOP_D2_JAR} )
            IF ( EXISTS ${FOP_D3_JAR} )
              IF ( EXISTS ${FOP_D4_JAR} )
                IF ( EXISTS ${FOP_D5_JAR} )
                  IF ( EXISTS ${FOP_D6_JAR} )
                    IF ( EXISTS ${FOP_D7_JAR} )
                      SET(ALL_FOP TRUE)
                    ENDIF ( EXISTS ${FOP_D7_JAR} )
                  ENDIF ( EXISTS ${FOP_D6_JAR} )
                ENDIF ( EXISTS ${FOP_D5_JAR} )
              ENDIF ( EXISTS ${FOP_D4_JAR} )
            ENDIF ( EXISTS ${FOP_D3_JAR} )
          ENDIF ( EXISTS ${FOP_D2_JAR} )
        ENDIF ( EXISTS ${FOP_D1_JAR} )
      ENDIF ( EXISTS ${FOP_JAR} )
      MESSAGE(STATUS "ALL_FOP:" ${ALL_FOP})

      IF ( ALL_FOP )
        MESSAGE(STATUS "FOP Libraries Found.")
        INCLUDE (CMakeJavaInformation )
        EXECUTE_PROCESS (
          COMMAND ${JAVA_RUNTIME} -version
          RESULT_VARIABLE JAVA_VERSION
          OUTPUT_QUIET
          ERROR_QUIET
        )

        INCLUDE_DIRECTORIES (${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2})
        INCLUDE_DIRECTORIES (${JAVA_INCLUDE_PATH})
        DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/xsl-fo" VERSION 1.0 FILE "xsl-fo.xq" LINK_LIBRARIES "${JAVA_JVM_LIBRARY}")

        DECLARE_ZORBA_JAR(FILE ${FOP_JAR} EXTERNAL)
        DECLARE_ZORBA_JAR(FILE ${FOP_D1_JAR} EXTERNAL)
        DECLARE_ZORBA_JAR(FILE ${FOP_D2_JAR} EXTERNAL)
        DECLARE_ZORBA_JAR(FILE ${FOP_D3_JAR} EXTERNAL)
        DECLARE_ZORBA_JAR(FILE ${FOP_D4_JAR} EXTERNAL)
        DECLARE_ZORBA_JAR(FILE ${FOP_D5_JAR} EXTERNAL)
        DECLARE_ZORBA_JAR(FILE ${FOP_D6_JAR} EXTERNAL)
        DECLARE_ZORBA_JAR(FILE ${FOP_D7_JAR} EXTERNAL)
        ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test")

      ELSE ( ALL_FOP )
        MESSAGE (STATUS "fop.jar and all its dependecies not found skiping data-formating module")
      ENDIF ( ALL_FOP )

    ELSE (JNI_FOUND)
      IF (ZORBA_WITH_FOP)
        MESSAGE(FATAL_ERROR "Could not find Java and/or JNI. Please install a JDK or compile Zorba with XSL-FO support by setting ZORBA_WITH_FOP to false.")
      ENDIF (ZORBA_WITH_FOP)
      MESSAGE ( STATUS "Not generating XSL-FO support: jni headers not found.")
    ENDIF(JNI_FOUND)
  
  ENDIF(ZORBA_SUPPRESS_JAVA)
ELSEIF (ZORBA_WITH_FOP)
    #SET(ZORBA_WITH_FOP OFF CACHE BOOL "Compile Zorba with XSL-FO support." FORCE)
    MESSAGE(STATUS "Building Zorba without XSL-FO support.")
ENDIF (ZORBA_WITH_FOP)
