/*
Copyright 2019 The Crossplane Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1alpha1

import (
	"github.com/crossplaneio/crossplane-runtime/apis/core/v1alpha1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// MinimalGCPSpec defines the desired state of MinimalGCP
type MinimalGCPSpec struct {
	// CredentialsSecretRef refers to the secret and its key that contains
	// the required credentials to connect to GCP.
	CredentialsSecretRef v1alpha1.SecretKeySelector `json:"credentialsSecretRef"`

	// ProjectID is the ID of the project in GCP that the resource will be
	// provisioned in.
	ProjectID string `json:"projectID"`

	// Region of the resources that will be deployed.
	Region string `json:"region"`
}

// MinimalGCPStatus defines the observed state of MinimalGCP
type MinimalGCPStatus struct {
	v1alpha1.ConditionedStatus `json:",inline"`
}

func (mg *MinimalGCP) GetCondition(ct v1alpha1.ConditionType) v1alpha1.Condition {
	return mg.Status.GetCondition(ct)
}

func (mg *MinimalGCP) SetConditions(c ...v1alpha1.Condition) {
	mg.Status.SetConditions(c...)
}

// +kubebuilder:object:root=true
// +kubebuilder:resource:scope=Cluster
// +kubebuilder:subresource:status

// MinimalGCP is the Schema for the minimalgcps API
type MinimalGCP struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   MinimalGCPSpec   `json:"spec,omitempty"`
	Status MinimalGCPStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// MinimalGCPList contains a list of MinimalGCP
type MinimalGCPList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []MinimalGCP `json:"items"`
}

func init() {
	SchemeBuilder.Register(&MinimalGCP{}, &MinimalGCPList{})
}
