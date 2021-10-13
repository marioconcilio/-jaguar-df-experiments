#!/bin/bash -v

sacct -j $1 --format=JobId,JobName%30,State,Start,End,Elapsed,NCPUs
