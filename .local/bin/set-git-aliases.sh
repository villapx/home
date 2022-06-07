#! /usr/bin/env bash

set_alias ()
{
    git config --global alias."$1" "$2"
}

set_alias rpo "remote prune origin"
