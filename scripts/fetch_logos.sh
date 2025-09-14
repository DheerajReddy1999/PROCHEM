#!/usr/bin/env bash
set -euo pipefail

# Downloads customer logos from Clearbit Logo API into photos/logos/
# Usage: bash scripts/fetch_logos.sh

out_dir="photos/logos"
mkdir -p "$out_dir"

download() {
  local domain="$1"; shift
  local file="$1"; shift
  local url="https://logo.clearbit.com/${domain}"
  echo "Fetching ${domain} -> ${out_dir}/${file}"
  if ! curl -fsSL "$url" -o "${out_dir}/${file}"; then
    echo "  ! Failed for ${domain}"
    rm -f "${out_dir}/${file}" || true
    return 1
  fi
}

# Try multiple domains until one succeeds
try_download() {
  local file="$1"; shift
  for domain in "$@"; do
    if download "$domain" "$file"; then
      return 0
    fi
  done
  echo "  -> All domains failed for ${file}; leaving placeholder (text fallback will show)"
}

# Confirmed domains
download aurobindo.com                aurobindo-pharma.png
download meil.in                      meil.png
download granulesindia.com            granules-india.png
try_download hindustan-coca-cola-beverages.png hccb.in hindustancoca-cola.com coca-colaindia.com
download archpharmalabs.com           arch-pharmalabs.png
download sanzymebiologics.com         sanzyme-biologics.png
try_download msn-laboratories.png msnlabs.com msnlaboratories.com msn-labs.com msnlabs.in

# Remaining customers — best-guess domains; fallback shows text label if none resolve
try_download srinath-roto-pack.png srinathrotopack.com srinathrotopack.in srppl.com
try_download bomidaila-group-of-industries.png bomidailagroup.com bomidaila.com
try_download meenakshi-power-plant.png meenakshienergy.com meenakshipower.com
try_download gayathri-power.png gayatri.co.in gayatripower.com gayatrienergy.com
try_download pharmajel.png pharmajel.com pharmajel.in
try_download sionc-pharma.png sioncpharma.com sionc.com sionc.in
try_download mk-pharma.png mkpharma.com mkpharma.in
try_download amri.png amriglobal.com curia.co amrihospitals.in
try_download slns-industries.png slnsindustries.com slns.in
try_download maathrusri-engineers.png maathrusriengineers.com maathrusri.com
download suven.com                    suven-life-sciences.png
download biophore.com                 biophore-india.png
download sembcorp.com                 sembcorp-energy-india.png

echo "Done. Logos saved under ${out_dir}/ (missing ones will show text labels)."
