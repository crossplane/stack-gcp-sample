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
	"github.com/go-logr/logr"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"

	gcpv1alpha1 "github.com/crossplaneio/minimal-gcp/api/v1alpha1"
	"github.com/muvaf/configuration-stacks/pkg/controllers"
)

// MinimalGCPReconciler reconciles a MinimalGCP object
type MinimalGCPReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
}

func (r *MinimalGCPReconciler) SetupWithManager(mgr ctrl.Manager) error {
	csr := controllers.NewResurcePackReconciler(mgr, gcpv1alpha1.MinimalGCPGroupVersionKind)
	return ctrl.NewControllerManagedBy(mgr).
		For(&gcpv1alpha1.MinimalGCP{}).
		Complete(csr)
}
