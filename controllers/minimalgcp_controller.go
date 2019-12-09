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

package controllers

import (
	"fmt"

	"github.com/go-logr/logr"
	"github.com/muvaf/configuration-stacks/pkg/controllers"
	"github.com/muvaf/configuration-stacks/pkg/resource"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/kustomize/api/resid"
	"sigs.k8s.io/kustomize/api/types"

	gcpv1alpha1 "github.com/crossplaneio/minimal-gcp/api/v1alpha1"
)

// MinimalGCPReconciler reconciles a MinimalGCP object
type MinimalGCPReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
}

func (r *MinimalGCPReconciler) SetupWithManager(mgr ctrl.Manager) error {
	csr := controllers.NewConfigurationStackReconciler(mgr, gcpv1alpha1.MinimalGCPGroupVersionKind,
		controllers.AdditionalKustomizationPatcher(resource.KustomizationPatcherFunc(AddVariants)))
	return ctrl.NewControllerManagedBy(mgr).
		For(&gcpv1alpha1.MinimalGCP{}).
		Complete(csr)
}

func AddVariants(resource resource.ParentResource, k *types.Kustomization) error {
	cr, ok := resource.(*gcpv1alpha1.MinimalGCP)
	if !ok {
		return fmt.Errorf("the resource is not of type %s", gcpv1alpha1.MinimalGCPGroupVersionKind)
	}
	ref := types.Target{
		Gvk: resid.Gvk{
			Group:   cr.GroupVersionKind().Group,
			Version: cr.GroupVersionKind().Version,
			Kind:    cr.GroupVersionKind().Kind,
		},
		Name:      cr.GetName(),
		Namespace: cr.GetNamespace(),
	}

	variants := []types.Var{
		{
			Name:   "REGION",
			ObjRef: ref,
			FieldRef: types.FieldSelector{
				FieldPath: "spec.region",
			},
		},
		{
			Name:   "GCP_PROJECT_ID",
			ObjRef: ref,
			FieldRef: types.FieldSelector{
				FieldPath: "spec.projectID",
			},
		},
		{
			Name:   "CRED_SECRET_KEY",
			ObjRef: ref,
			FieldRef: types.FieldSelector{
				FieldPath: "spec.credentialsSecretRef.key",
			},
		},
		{
			Name:   "CRED_SECRET_NAME",
			ObjRef: ref,
			FieldRef: types.FieldSelector{
				FieldPath: "spec.credentialsSecretRef.name",
			},
		},
		{
			Name:   "CRED_SECRET_NAMESPACE",
			ObjRef: ref,
			FieldRef: types.FieldSelector{
				FieldPath: "spec.credentialsSecretRef.namespace",
			},
		},
	}
	k.Vars = append(k.Vars, variants...)
	return nil
}
