#!/bin/bash -v

sacct -j $1 --format=JobId,JobName,State,Start,End,Elapsed,NCPUs
