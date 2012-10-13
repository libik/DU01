def dfs(verticesarray, numofvertices, usedvertices, thisvertex, arraytoreturn)
  usedvertices[thisvertex] = true;
  arraytoreturn << thisvertex
  for k in 1..numofvertices
    if ((usedvertices[k] == false) and (verticesarray[thisvertex][k] == true))
      dfs(verticesarray, numofvertices, usedvertices, k, arraytoreturn)
    end
  end
end

def bfs(verticesarray, numofvertices, usedvertices, arraytoreturn, localarray)
  arraytonext = Array.new(0)
  usedvertices[localarray[0]] = true;
  for o in 0..localarray.length-1 do
    for k in 1..numofvertices
      if ((usedvertices[k] == false) and (verticesarray[localarray[o]][k] == true))
        arraytoreturn << k
        usedvertices[k] = true;
        arraytonext << k
      end
    end
  end

  if (arraytonext.length > 0)
    bfs(verticesarray, numofvertices, usedvertices, arraytoreturn, arraytonext)
  end
  
end


def loaddata (file)
  toreturn = Array.new(0)
  IO.foreach(file) do |line|
    pole = line.scan(/\w+/)
    toreturn = toreturn + pole
  end
  return toreturn
end

def compare_files(out, expected)
  if (File.exist?(expected) == false)
    puts "neexistuje"
  end
  if (File.exist?(out) == false)
    puts "neexistuje"
  end

  if (File.size(out) <= 0)
    puts "neni vetsi"
  end

  tested = File.open(out, 'r')
  File.open(expected, 'r') do |f|
    kontrola = true;
    f.each do|line|
      if (line != tested.readline)
        kontrola = false
      end
    end
    if (kontrola)
      puts "Souhlasi"
    end
    if (kontrola == false)
      puts "Nesouhlasi"
    end
  end
end

def run_search(input_file)
  $out_file = "./out.test"
  $stdout = File.new($out_file, 'w')

  input = "./input/" + input_file
  mygraph(input)

  $stdout.close
  $stdout = STDOUT
end

def expected_output(filename)
  return "./output/" + filename
end

def most_allocated_obj
  puts "\nMost allocated objects\n"
  types = Hash.new(0)
  ObjectSpace.each_object { |obj|
    types[obj.class] += 1
  }
  pp types.sort_by { |klass,num|  num }.reverse.to_a[0,10]
end

def mygraph(input)
  pole = loaddata(input)

  for aa in 0..pole.length do
    pole[aa] = pole[aa].to_i
  end

  pos = 1;
  for xx in 1..pole[0] do
    puts "graph " + xx.to_s
    numofvertices = pole[pos]
    useablearray = Array.new(numofvertices+1) {Array.new(numofvertices+1) {0}}
    for i in 1..numofvertices
      for j in 1..numofvertices
        useablearray[i][j] = false
      end
    end

    for yy in 1..pole[pos]
      pos += 1
      vertex = pole[pos]
      pos += 1
      for yz in 1..pole[pos]
        pos += 1
        useablearray[vertex][pole[pos]] = true
        useablearray[pole[pos]][vertex] = true
      end
    end
    pos += 1
    while pole[pos] != 0
      arraytoreturn = Array.new(0)
      usedvertices = Array.new(numofvertices+1)
      for ac in 1..numofvertices do
        usedvertices[ac] = false
      end
      if (pole[pos+1] == 0)
        dfs(useablearray, numofvertices, usedvertices, pole[pos], arraytoreturn)
      end
      if (pole[pos+1] == 1)
        arraytoreturn << pole[pos]
        localarray = Array.new(0)
        localarray << pole[pos];
        bfs(useablearray, numofvertices, usedvertices, arraytoreturn, localarray)
      end
      puts arraytoreturn.join(" ")
      pos += 2
    end

    pos += 2

  end
end


file = "g01.txt"
run_search(file)
compare_files($out_file, expected_output(file))

file = "g05.txt"
run_search(file)
compare_files($out_file, expected_output(file))

file = "g10.txt"
run_search(file)
compare_files($out_file, expected_output(file))

file = "g30.txt"
run_search(file)
compare_files($out_file, expected_output(file))

file = "g50.txt"
run_search(file)
compare_files($out_file, expected_output(file))


file = "g100.txt"
run_search(file)
compare_files($out_file, expected_output(file))

file = "g200bfs.txt"
run_search(file)
compare_files($out_file, expected_output(file))

file = "g200dfs.txt"
run_search(file)
compare_files($out_file, expected_output(file))

file = "g500.txt"
run_search(file)
compare_files($out_file, expected_output(file))

file = "g1000.txt"
run_search(file)
compare_files($out_file, expected_output(file))
