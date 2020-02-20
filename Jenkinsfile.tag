// Load a library dynamically. For more detail, see:
// https://jenkins.io/doc/book/pipeline/shared-libraries/#defining-declarative-pipelines
library identifier: 'stack-cicd@master', retriever: modernSCM(
  [$class: 'GitSCMSource',
   remote: 'https://github.com/suskin/stack-cicd',
   credentialsId: 'github-upbound-jenkins'])

// This is the name of a file declared in vars/{{fileName}}.groovy in the library repository.
runStackTagPipeline()
