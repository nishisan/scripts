#!/bin/bash
getUserDir(){
	return getent passwd $1 | cut -d: -f6
}
