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

MESSAGE(STATUS "")
MESSAGE(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
MESSAGE(STATUS "Configuring external module <data-formatting>")
MESSAGE(STATUS "-------------------------------------------------------------")
MESSAGE(STATUS "")

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

PROJECT (zorba_data-formatting_module)

FIND_PACKAGE (zorba_util-jvm_module QUIET)
INCLUDE ("${zorba_util-jvm_module_USE_FILE}")
INCLUDE(${CMAKE_CURRENT_SOURCE_DIR}/config/UtilJavaUse.cmake)

IF (zorba_util-jvm_module_FOUND)
  FIND_PACKAGE (Zorba REQUIRED HINTS "${ZORBA_BUILD_DIR}")
  INCLUDE ("${Zorba_USE_FILE}")
  
  SET_CMAKE_MODULE_PATH ()
  ZORBA_FIND_JNI()
  FIND_PACKAGE(Java)

  IF (JNI_FOUND)
    INCLUDE_DIRECTORIES (${zorba_util-jvm_module_INCLUDE_DIRS})

    ENABLE_TESTING ()
    INCLUDE (CTest)

    FIND_PACKAGE (Zorba REQUIRED HINTS "${ZORBA_BUILD_DIR}")
    INCLUDE ("${Zorba_USE_FILE}")

    IF (NOT DEFINED XSL_FOP_HOME)
      IF (DEFINED ENV{XSL_FOP_HOME})
        SET(XSL_FOP_HOME $ENV{XSL_FOP_HOME})
      ENDIF (DEFINED ENV{XSL_FOP_HOME})
    ENDIF (NOT DEFINED XSL_FOP_HOME)

    IF (NOT DEFINED XSL_FOP_HOME)
      IF (WIN32)
        SET (XSL_FOP_HOME "C:\\dev\\libraries\\fop-1.0 C:\\dev\\libraries\\fop-1.0\\lib C:\\dev\\libraries\\fop-1.0\\build")
      ELSE (WIN32)
        SET (XSL_FOP_HOME /usr/share/java/ /usr/share/java/fop/ /opt/local/share/java/fop/1.0 /opt/local/share/java/fop/1.0 ${Java_LIBRARIES})
      ENDIF (WIN32)
      MESSAGE (STATUS "XSL_FOP_HOME not defined, trying defaults: ${XSL_FOP_HOME}")
    ENDIF (NOT DEFINED XSL_FOP_HOME)

    STRING(REGEX REPLACE "\\\\" "/" XSL_FOP_HOME "${XSL_FOP_HOME}")

    MESSAGE (STATUS "XSL-FOP HOME: ${XSL_FOP_HOME}")
    ZORBA_FIND_JAR ( FOP_JAR    NAMES fop
      PATHS ${XSL_FOP_HOME} PATH_SUFFIXES build)
    ZORBA_FIND_JAR ( FOP_D1_JAR NAMES avalon-framework
      PATHS ${XSL_FOP_HOME} PATH_SUFFIXES lib )
    ZORBA_FIND_JAR ( FOP_D2_JAR NAMES batik-all
      PATHS ${XSL_FOP_HOME} PATH_SUFFIXES lib )
    ZORBA_FIND_JAR ( FOP_D3_JAR NAMES commons-io
      PATHS ${XSL_FOP_HOME} PATH_SUFFIXES lib )
    ZORBA_FIND_JAR ( FOP_D4_JAR NAMES commons-logging
      PATHS ${XSL_FOP_HOME} PATH_SUFFIXES lib )
    ZORBA_FIND_JAR ( FOP_D5_JAR NAMES xalan xalan2
      PATHS ${XSL_FOP_HOME} PATH_SUFFIXES lib )
    ZORBA_FIND_JAR ( FOP_D6_JAR NAMES xmlgraphics-commons
      PATHS ${XSL_FOP_HOME} PATH_SUFFIXES lib )

    # Multiple "EXISTS" clauses can't be used in a single IF() command;
    # looks like a bug in cmake.
    SET(ALL_FOP FALSE)
    IF ( EXISTS ${FOP_JAR} )
      IF ( EXISTS ${FOP_D1_JAR} )
        IF ( EXISTS ${FOP_D2_JAR} )
          IF ( EXISTS ${FOP_D3_JAR} )
            IF ( EXISTS ${FOP_D4_JAR} )
              IF ( EXISTS ${FOP_D5_JAR} )
                IF ( EXISTS ${FOP_D6_JAR} )
                  SET(ALL_FOP TRUE)
                ENDIF ( EXISTS ${FOP_D6_JAR} )
              ENDIF ( EXISTS ${FOP_D5_JAR} )
            ENDIF ( EXISTS ${FOP_D4_JAR} )
          ENDIF ( EXISTS ${FOP_D3_JAR} )
        ENDIF ( EXISTS ${FOP_D2_JAR} )
      ENDIF ( EXISTS ${FOP_D1_JAR} )
    ENDIF ( EXISTS ${FOP_JAR} )

    IF ( ALL_FOP )
      MESSAGE(STATUS "FOP Libraries Found.")
      INCLUDE (CMakeJavaInformation)
      EXECUTE_PROCESS (
        COMMAND ${JAVA_RUNTIME} -version
        RESULT_VARIABLE JAVA_VERSION
        OUTPUT_QUIET
        ERROR_QUIET
     )

      INCLUDE_DIRECTORIES (${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2})
      INCLUDE_DIRECTORIES (${JAVA_INCLUDE_PATH})
    
      DECLARE_ZORBA_JAR(FILE ${FOP_JAR} EXTERNAL)
      DECLARE_ZORBA_JAR(FILE ${FOP_D1_JAR} EXTERNAL)
      DECLARE_ZORBA_JAR(FILE ${FOP_D2_JAR} EXTERNAL)
      DECLARE_ZORBA_JAR(FILE ${FOP_D3_JAR} EXTERNAL)
      DECLARE_ZORBA_JAR(FILE ${FOP_D4_JAR} EXTERNAL)
      DECLARE_ZORBA_JAR(FILE ${FOP_D5_JAR} EXTERNAL)
      DECLARE_ZORBA_JAR(FILE ${FOP_D6_JAR} EXTERNAL)

      ADD_SUBDIRECTORY ("src")
      ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test")
      
      MESSAGE(STATUS "")
      MESSAGE(STATUS "-------------------------------------------------------------")
      MESSAGE(STATUS "Configuration SUCCEEDED for external module <data-formatting>")

    ELSE ( ALL_FOP )
      MESSAGE (STATUS "fop.jar and/or all its dependecies (avalon-framework.jar, batik-all.jar, commons-io.jar, commons-logging.jar, xalan2.jar, xmlgraphics-commons.jar) not found skiping data-formating module")
      MESSAGE (STATUS " fop: " ${FOP_JAR} 
                      "\n    avalon: " ${FOP_D1_JAR}
                      "\n    batik: " ${FOP_D2_JAR}
                      "\n    io: " ${FOP_D3_JAR}
                      "\n    logging: " ${FOP_D4_JAR}
                      "\n    xalan: " ${FOP_D5_JAR}
                      "\n    xmlgraphics: " ${FOP_D6_JAR} )
      MESSAGE(STATUS "")
      MESSAGE(STATUS "-------------------------------------------------------------")  
      MESSAGE(STATUS "Configuration FAILED for external module <data-formatting>")
    ENDIF ( ALL_FOP )    
    
  ELSE (JNI_FOUND)
    MESSAGE ( STATUS "Java and/or JNI not found; skipping data-formating module.")
    
    MESSAGE(STATUS "")
    MESSAGE(STATUS "-------------------------------------------------------------")  
    MESSAGE(STATUS "Configuration FAILED for external module <data-formatting>")
    
  ENDIF(JNI_FOUND)

ELSE (zorba_util-jvm_module_FOUND)
  MESSAGE (STATUS "Zorba's util-jvm module not found; skipping data-formatting module.")
  
  MESSAGE(STATUS "")
  MESSAGE(STATUS "-------------------------------------------------------------")  
  MESSAGE(STATUS "Configuration FAILED for external module <data-formatting>")
  
ENDIF (zorba_util-jvm_module_FOUND)

MESSAGE(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
