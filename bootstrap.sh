#!/usr/bin/env bash
set -euo pipefail

# Nom du répertoire racine du projet (à adapter si besoin)
ROOT_DIR="aws-networking-lab"

# Listes des modules et fichiers à créer
MODULES=(
  "vpc"
  "transit_gateway"
  "tgw_attachment"
  "vpn_connection"
  "interface_endpoint"
  "gateway_endpoint"
  "gwlb_endpoint"
)

MODULE_FILES=(
  "main.tf"
  "variables.tf"
  "outputs.tf"
)

ROOT_FILES=(
  "backend.tf"
  "main.tf"
  "variables.tf"
  "outputs.tf"
)

# Créer la racine du projet
mkdir -p "${ROOT_DIR}"
cd "${ROOT_DIR}"

echo "Création de la structure de répertoires pour aws-networking-lab ..."

# 1) Créer le dossier modules/ et ses sous-dossiers
mkdir -p modules
for mod in "${MODULES[@]}"; do
  mkdir -p "modules/${mod}"
  for file in "${MODULE_FILES[@]}"; do
    touch "modules/${mod}/${file}"
  done

  # Cas particulier : ajouter tags.tf dans modules/vpc
  if [ "$mod" = "vpc" ]; then
    touch "modules/vpc/tags.tf"
  fi
done

# 2) Créer les fichiers à la racine du projet
for file in "${ROOT_FILES[@]}"; do
  touch "${file}"
done

echo "Structure créée :"



echo ""
echo "✅ Arborescence initiale créée avec succès."
echo "Vous pouvez maintenant ouvrir ces fichiers pour y coller le contenu Terraform approprié."

