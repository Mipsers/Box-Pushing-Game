infile1 = open("./data.txt", 'r')
infile2 = open("./pages.txt", 'r')
outfile = open("./res.txt", "w")

file1 = [line for line in infile1]
file2 = [line for line in infile2]
outf = ["v2.0 raw\n"]
outf.extend(file1)
outf.extend(["00000000\n" for i in range(0xc00-len(file1))])
outf.extend(file2)

print(len(outf), 0xc00)

outfile.writelines(outf)
