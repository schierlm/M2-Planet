/* Copyright (C) 2016 Jeremiah Orians
 * This file is part of M2-Planet.
 *
 * M2-Planet is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * M2-Planet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with M2-Planet.  If not, see <http://www.gnu.org/licenses/>.
 */

#define MAX_STRING 4096
// CONSTANT MAX_STRING 4096

int main()
{
	char* current_path = calloc(MAX_STRING, sizeof(char));
	getcwd(current_path, MAX_STRING);
	char* base_path = calloc(MAX_STRING, sizeof(char));
	copy_string(base_path, current_path);

	/* Test they all evaluate to the same */
	char* current_path_getwd = calloc(MAX_STRING, sizeof(char));
	getwd(current_path_getwd);
	if(!match(current_path, current_path_getwd))
	{
		return 1;
	}
	char* current_path_dir_name = calloc(MAX_STRING, sizeof(char));
	current_path_dir_name = get_current_dir_name();
	if(!match(current_path, current_path_dir_name))
	{
		return 2;
	}

	/* Test chdir works */
	int chdir_rc = chdir(prepend_string(base_path, "/test/test27"));
	if(chdir_rc != 0)
	{
		return 3;
	}
	getcwd(current_path, MAX_STRING);
	if(!match(current_path, prepend_string(base_path, "/test/test27")))
	{
		return 4;
	}
	chdir(prepend_string(current_path, "/../.."));
	getcwd(current_path, MAX_STRING);

	/* Test fchdir works */
	FILE* fchdir_fd = open(prepend_string(base_path, "/test/test27"), 0, 0);
	int fchdir_rc = fchdir(fchdir_fd);
	if(fchdir_rc != 0)
	{
		return 5;
	}
	getcwd(current_path, MAX_STRING);
	if(!match(current_path, prepend_string(base_path, "/test/test27")))
	{
		return 6;
	}
	chdir(prepend_string(current_path, "/../.."));

	/* All tests passed */
	return 0;
}
