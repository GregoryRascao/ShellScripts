#!/bin/bash

set -e

print_ok() {
  echo -e "\e[1;37m[\e[1;32m  OK  \e[1;37m] $1"
}

print_info() {
  # les codes couleurs : https://www.geeksforgeeks.org/linux-unix/how-to-change-the-output-color-of-echo-in-linux/
  echo -e "\e[1;37m[\e[1;37m INFO \e[1;37m] $1"
}

print_warning() {
  echo -e "\e[1;37m[\e[1;33m WARNING \e[1;37m] $1" >&2
}

print_error() {
  echo -e "\e[1;37m[\e[1;91m ERROR \e[1;37m] $1" >&2
}

print_critical() {
  echo -e "\e[1;37m[\e[1;31m CRITICAL \e[1;37m] $1" >&2
  exit 99
}

print_info "ceci est une information"
print_ok "La command s'est bien passé"
print_warning "Attetion il manque des informations !"
print_error "Une erreur s'est produite"
print_critical "Une erreur critique s'est produite !"