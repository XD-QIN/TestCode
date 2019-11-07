import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as opt # we'll need this later
import scipy.io as sio

dataset = sio.loadmat("motions10fps.mat")
window_length = 2
X = np.array([])
X_output = np.array([])
Y = np.array([])
Y_output = np.array([])
Z = np.array([])
Z_output =np.array([])
for i in range(dataset["allData"].shape[0]): #16
    for j in range(dataset["allData"].shape[1]): #154
        if dataset["allData"][i, j].shape[1] !=0: # not empty
            for k in range(dataset["allData"][i, j][0,:].shape[0]): #4 
                    m = 0
                    p = 0
                    q = 0
                    if k == 1: 
                        while m+window_length  <= dataset["allData"][i, j][:,:].shape[0] - 1:#299-1 
                            if Y.shape[0] == 0:
                                Y = np.hstack((Y, dataset["allData"][i, j][m:m+window_length,1]))
                                Y_output = np.hstack((Y_output, dataset["allData"][i, j][m+window_length,1]))
                            else:
                                Y = np.vstack((Y, dataset["allData"][i, j][m:m+window_length,1]))
                                Y_output = np.vstack((Y_output, dataset["allData"][i, j][m+window_length,1]))
                            m = m + 1
                    if k == 2:
                        while p+window_length  <= dataset["allData"][i, j][:,:].shape[0] - 1:  
                            if X.shape[0] == 0:
                                X = np.hstack((X, dataset["allData"][i, j][p:p+window_length,2]))
                                X_output = np.hstack((X_output, dataset["allData"][i, j][p+window_length,2]))
                            else:
                                X = np.vstack((X, dataset["allData"][i, j][p:p+window_length,2])) 
                                X_output = np.vstack((X_output, dataset["allData"][i, j][p+window_length,2]))
                            p = p + 1
                    if k == 3:
                        while q+window_length  <= dataset["allData"][i, j][:,:].shape[0] - 1: 
                            if Z.shape[0] == 0:
                                Z = np.hstack((Z, dataset["allData"][i, j][q:q+window_length,3]))
                                Z_output = np.hstack((Z_output, dataset["allData"][i, j][q+window_length,3]))
                            else:
                                Z = np.vstack((Z, dataset["allData"][i, j][q:q+window_length,3])) 
                                Z_output = np.vstack((Z_output, dataset["allData"][i, j][q+window_length,3]))
                            q = q + 1
            print("(" +str(i)+"," + str(j)+ ") is done!") # i--video ID, j--user ID
        else:
            print("(" +str(i)+"," + str(j)+ ") is empty!") # i--video ID, j--user I
sio.savemat('X_'+str(window_length)+'.mat', {'X_'+str(window_length):X})
sio.savemat('X_output'+str(window_length)+'.mat', {'X_output'+str(window_length):X_output})
sio.savemat('Y_'+str(window_length)+'.mat', {'Y_'+str(window_length):Y})
sio.savemat('Y_output'+str(window_length)+'.mat', {'Y_output'+str(window_length):Y_output})
sio.savemat('Z_'+str(window_length)+'.mat', {'Z_'+str(window_length):Z})
sio.savemat('Z_output'+str(window_length)+'.mat', {'Z_output'+str(window_length):Z_output})
print('all done!')