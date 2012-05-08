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




  IF (NOT DEFINED XSL_FOP_HOME)
    IF (DEFINED ENV{XSL_FOP_HOME})
      SET(XSL_FOP_HOME $ENV{XSL_FOP_HOME})
    ENDIF (DEFINED ENV{XSL_FOP_HOME})
  ENDIF (NOT DEFINED XSL_FOP_HOME)
  
  IF (NOT DEFINED XSL_FOP_HOME)
    IF (WIN32)
      MESSAGE (STATUS "Environment variable XSL_FOP_HOME not defined, trying default: C:\\dev\\libraries\\fop-1.0")
      SET (XSL_FOP_HOME "C:\\dev\\libraries\\fop-1.0 C:\\dev\\libraries\\fop-1.0\\lib")
    ELSE (WIN32)
      SET (UNIX_FOP_DEFAULTS /usr/share/java/ /usr/share/java/fop/ /opt/local/share/java/fop/1.0/lib /opt/local/share/java/fop/1.0/build/ ${Java_LIBRARIES})
      MESSAGE (STATUS "Environment variable XSL_FOP_HOME not defined, trying defaults: " ${UNIX_FOP_DEFAULTS})
      SET (XSL_FOP_HOME ${UNIX_FOP_DEFAULTS})
    ENDIF (WIN32)
  ENDIF (NOT DEFINED XSL_FOP_HOME)
  
  STRING(REGEX REPLACE "\\\\" "/" XSL_FOP_HOME "${XSL_FOP_HOME}")
  
  MESSAGE (STATUS "XSL-FOP HOME: " ${XSL_FOP_HOME} )
  FIND_FILE( FOP_JAR    NAMES fop.jar
    PATHS ${XSL_FOP_HOME} )
  FIND_FILE( FOP_D1_JAR NAMES avalon-framework.jar avalon-framework-4.2.0.jar
    PATHS ${XSL_FOP_HOME} )
  FIND_FILE( FOP_D2_JAR NAMES batik-all.jar /batik-all-1.7.jar
    PATHS ${XSL_FOP_HOME} )
  FIND_FILE( FOP_D3_JAR NAMES commons-io.jar commons-io-1.3.1.jar
    PATHS ${XSL_FOP_HOME} )
  FIND_FILE( FOP_D4_JAR NAMES commons-logging.jar commons-logging-1.0.4.jar
    PATHS ${XSL_FOP_HOME} )
  FIND_FILE( FOP_D5_JAR NAMES serializer.jar serializer-2.7.0.jar
    PATHS ${XSL_FOP_HOME} )
  FIND_FILE( FOP_D6_JAR NAMES xalan.jar xalan2.jar xalan-2.7.0.jar
    PATHS ${XSL_FOP_HOME} )
  FIND_FILE( FOP_D7_JAR NAMES xmlgraphics-commons.jar xmlgraphics-commons-1.4.jar
    PATHS ${XSL_FOP_HOME} )

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
    DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/xsl-fo"
      VERSION 1.0 FILE "xsl-fo.xq"
      LINK_LIBRARIES "${JAVA_JVM_LIBRARY}" ${zorba_util-jvm_module_LIBRARIES})

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
    MESSAGE (STATUS "fop.jar and/or all its dependecies (avalon-framework.jar, batik-all.jar, commons-io.jar, commons-logging.jar, serializer.jar, xalan2.jar, xmlgraphics-commons.jar) not found skiping data-formating module")
    MESSAGE ( STATUS " fop: " ${FOP_JAR} "\n    avalon: " ${FOP_D1_JAR}
  			"\n    batik: " ${FOP_D2_JAR} "\n    io: " ${FOP_D3_JAR} 
  			"\n    logging: " ${FOP_D4_JAR} "\n    serializer: " ${FOP_D5_JAR} "  " 
  			"\n    xalan: " ${FOP_D6_JAR} "\n    xmlgraphics: " ${FOP_D7_JAR} )
  ENDIF ( ALL_FOP )

