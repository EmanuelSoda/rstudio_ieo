FROM emanuelsoda/rstudio_seurat:latest

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install  scvi-tools 
RUN python3 -m pip install --no-cache-dir  scvi-tools 

# Install  PhenoGraph
RUN python3 -m pip install --no-cache-dir  PhenoGraph 

# Install  palantir
RUN python3 -m pip install --no-cache-dir  palantir 

########### Install R Packages #########

# Install dyno 
RUN R --no-echo --no-restore --no-save -e "devtools::install_github('dynverse/dyno')"

# Install swne 
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('linxihui/NNLM')"

RUN R --no-echo --no-restore --no-save -e "devtools::install_github('aertslab/RcisTarget')"

RUN R --no-echo --no-restore --no-save -e "BiocManager::install('AUCell')"

RUN R --no-echo --no-restore --no-save -e "devtools::install_github('aertslab/cisTopic')"

RUN R --no-echo --no-restore --no-save -e "remotes::install_github('yanwu2014/swne')"

# Install scPred
RUN R --no-echo --no-restore --no-save -e "devtools::install_github('powellgenomicslab/scPred')"

%post -c /bin/bash
    # install packages 
    apt-get update -qq && apt-get -y --no-install-recommends install \
    openssh-server

    # e.g. install ggtree
    R -e 'BiocManager::install("ggtree")'
    
    # function to add host machine commands using to continer using ssh
    # https://groups.google.com/a/lbl.gov/forum/#!topic/singularity/syLcsIWWzdo
    
    BIN_DIR=/usr/local/bin
    
    function add_host_command {
      host_exe=$1
      local_exe=$2
      echo \
        '#!/bin/bash
        ssh $VERBOSE_FLAG ${USER}@${HOSTNAME} ' " $host_exe " '$@' > ${BIN_DIR}/${local_exe}
    
      chmod +x ${BIN_DIR}/${local_exe}
    }
# full path required for host command 
    # e.g. add_host_command /opt/pbs/bin/qsub qsub
    # add all PBS commands
    add_host_command /opt/pbs/bin/mpiexec mpiexec
    add_host_command /opt/pbs/bin/nqs2pbs nqs2pbs
    add_host_command /opt/pbs/bin/pbs_attach pbs_attach
    add_host_command /opt/pbs/bin/pbsdsh pbsdsh
    add_host_command /opt/pbs/bin/pbs_hostn pbs_hostn
    add_host_command /opt/pbs/bin/pbs_lamboot pbs_lamboot
    add_host_command /opt/pbs/bin/pbs_migrate_users pbs_migrate_users
    add_host_command /opt/pbs/bin/pbs_mpihp pbs_mpihp
    add_host_command /opt/pbs/bin/pbs_mpilam pbs_mpilam
    add_host_command /opt/pbs/bin/pbs_mpirun pbs_mpirun
    add_host_command /opt/pbs/bin/pbsnodes pbsnodes
    add_host_command /opt/pbs/bin/pbs_password pbs_password
    add_host_command /opt/pbs/bin/pbs_python pbs_python
    add_host_command /opt/pbs/bin/pbs_ralter pbs_ralter
    add_host_command /opt/pbs/bin/pbs_rdel pbs_rdel
    add_host_command /opt/pbs/bin/pbs_release_nodes pbs_release_nodes
    add_host_command /opt/pbs/bin/pbs_remsh pbs_remsh
    add_host_command /opt/pbs/bin/pbs_rstat pbs_rstat
    add_host_command /opt/pbs/bin/pbs_rsub pbs_rsub
    add_host_command /opt/pbs/bin/pbsrun pbsrun
    add_host_command /opt/pbs/bin/pbsrun_unwrap pbsrun_unwrap
    add_host_command /opt/pbs/bin/pbsrun_wrap pbsrun_wrap
    add_host_command /opt/pbs/bin/pbs_tclsh pbs_tclsh
    add_host_command /opt/pbs/bin/pbs_tmrsh pbs_tmrsh
    add_host_command /opt/pbs/bin/pbs_topologyinfo pbs_topologyinfo
    add_host_command /opt/pbs/bin/pbs_wish pbs_wish
    add_host_command /opt/pbs/bin/printjob printjob
    add_host_command /opt/pbs/bin/printjob.bin printjob.bin
    add_host_command /opt/pbs/bin/qalter qalter
    add_host_command /opt/pbs/bin/qdel qdel
    add_host_command /opt/pbs/bin/qdisable qdisable
    add_host_command /opt/pbs/bin/qenable qenable
    add_host_command /opt/pbs/bin/qhold qhold
    add_host_command /opt/pbs/bin/qmgr qmgr
    add_host_command /opt/pbs/bin/qmove qmove
    add_host_command /opt/pbs/bin/qmsg qmsg
    add_host_command /opt/pbs/bin/qorder qorder
    add_host_command /opt/pbs/bin/qrerun qrerun
    add_host_command /opt/pbs/bin/qrls qrls
    add_host_command /opt/pbs/bin/qrun qrun
    add_host_command /opt/pbs/bin/qselect qselect
    add_host_command /opt/pbs/bin/qsig qsig
    add_host_command /opt/pbs/bin/qstart qstart
    add_host_command /opt/pbs/bin/qstat qstat
    add_host_command /opt/pbs/bin/qstop qstop
    add_host_command /opt/pbs/bin/qsub qsub
    add_host_command /opt/pbs/bin/qterm qterm
    add_host_command /opt/pbs/bin/tracejob tracejob


