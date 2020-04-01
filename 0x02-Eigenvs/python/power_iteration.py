import numpy as np

A = np.array([[5, 5], [2, 8]])
#A = np.array([[6,-1], [2,3]])
#A = np.array([[3,2,4], [2,0,2], [4,2,3]])
#A = np.array([[12,-51,4], [6,167,-68], [-4,24,-41]])

def power_iteration(A, num_simulations):
  b_k = np.random.rand(A.shape[1])

  for _ in range(num_simulations):
    # calculate the matrix-by-vector product Ab
    b_k1 = np.dot(A, b_k)

    # calculate the norm
    b_k1_norm = np.linalg.norm(b_k1)

    # re normalize the vector
    b_k = b_k1 / b_k1_norm

  return b_k



print("%s\n"%power_iteration(A, 32))

w, v = np.linalg.eig(A)

print(w)
print(v)
