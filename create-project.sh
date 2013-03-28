#!/bin/sh
gs=$(tput setaf 2)
ge=$(tput op)

echo "${gs}creating project:${ge} $1"

if [[ ! -e $1 ]]; then
  mkdir $1
fi

cd $1

buildfile=$(cat <<EOF
apply plugin: 'java'

repositories {
    mavenCentral()
}

dependencies {
    testCompile 'junit:junit:4.10'
}

task "init-project" << {
  sourceSets*.java.srcDirs*.each { File dir ->
    if(!dir.exists()) {
      println "creating \$dir"
      dir.mkdirs()
    } else {
      println "skipping \$dir"
    }
  }

  sourceSets*.resources.srcDirs*.each { File dir ->
    if(!dir.exists()) {
      println "creating directory \$dir"
      dir.mkdirs()
    }else {
      println "skipping \$dir"
    }
  }
}
EOF)

if [[ ! -e build.gradle ]]; then
  echo "${gs}creating build file:${ge} build.gradle"
  echo "${buildfile}" > build.gradle
else
  echo "skipping build file"
fi

echo "${gs}>>> setting up project${ge}"
gradle init-project
echo "${gs}<<< done${ge}"

if [[ ! -e .git ]]; then
  git init
else
  echo "skipping git initialization"
fi

gitignore=$(cat <<EOF
*.un~
*.iml
*.ipr
*.iws
build
.gradle
EOF)

if [[ ! -e .gitignore ]]; then
  echo "${gs}creating git ignores:${ge} .gitignore"
  echo "${gitignore}" > .gitignore
else
  echo "skipping git ignores"
fi

cd ..
