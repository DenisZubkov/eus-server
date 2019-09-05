#! /usr/bin/env bash

pkill swift
cd .build/release
./eus-server
cd -
